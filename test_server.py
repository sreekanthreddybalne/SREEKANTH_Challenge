import os
import ssl
import subprocess
from urllib.parse import urlparse

import OpenSSL
import pytest
import requests


def get_terraform_output(output_name):
    """Fetch the Terraform output value."""
    command = f"terraform output -raw {output_name}"
    try:
        result = subprocess.run(
            command,
            shell=True,
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Error fetching Terraform output: {e}")
        return None


@pytest.fixture(scope="module", autouse=True)
def self_signed_cert_path():
    """
    Fetch the path to our self-signed certificate.
    """
    cert_path = os.path.join(os.getcwd(), get_terraform_output("self_signed_cert_path"))
    # Set the `REQUESTS_CA_BUNDLE` environment variable in order to make "requests" package aware of the self-signed certificate.
    # Otherwise, SSL verification fails.
    os.environ["REQUESTS_CA_BUNDLE"] = cert_path
    return cert_path


@pytest.fixture
def ip_address():
    """
    Fetch the EC2 instance's IP address from terraform output
    """
    return get_terraform_output("web_server_ip")


@pytest.fixture
def project_name():
    """
    Fetch the Project name from terraform output
    """
    return get_terraform_output("project_name")


def test_http_status(ip_address):
    """
    Test that our web server accepts HTTP requests.
    """
    response = requests.get(f"http://{ip_address}")
    assert response.status_code == 200


def test_https_redirect(ip_address):
    """
    Test that our web server redirects HTTP requests to HTTPS.
    """
    response = requests.get(f"http://{ip_address}", allow_redirects=False)
    assert response.status_code == 301
    assert response.headers["Location"].startswith("https://")


def test_ssl_certificate(ip_address, project_name, self_signed_cert_path):
    """
    Test that our web server is using the self-signed certificate.
    """
    url = f"https://{ip_address}"
    parsed_url = urlparse(url)
    context = ssl.create_default_context()
    context.load_verify_locations(self_signed_cert_path)
    conn = context.wrap_socket(ssl.socket(), server_hostname=parsed_url.hostname)
    conn.connect((parsed_url.hostname, 443))
    cert = conn.getpeercert(True)
    x509 = OpenSSL.crypto.load_certificate(OpenSSL.crypto.FILETYPE_ASN1, cert)

    assert x509.get_subject().CN == project_name


def test_hello_world(ip_address):
    """
    Test to check that the web server returns "Hello World!" page.
    """
    response = requests.get(f"http://{ip_address}")
    assert "Hello World!" in response.text
