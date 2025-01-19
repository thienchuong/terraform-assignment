import os
import urllib3
import boto3
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Init cw client
cloudwatch_client = boto3.client("cloudwatch")

# Get ALB DNS URL from environment variables
ALB_DNS_URL = os.environ.get("ALB_DNS_URL")
SNS_TOPIC_ARN = os.environ.get("SNS_TOPIC_ARN")

def send_sns_alert():
    """Send an alert to the SNS topic."""
    if not SNS_TOPIC_ARN:
        logger.error("SNS_TOPIC_ARN environment variable is not set. Cannot send alert.")
        return
    try:
        sns_client.publish(
            TopicArn=SNS_TOPIC_ARN,
            Subject="Web App health check alert",
            Message="The web app health check failed. pls investigate",
        )
        logger.info("SNS alert sent successfully")
    except Exception as e:
        logger.error(f"Failed to send SNS alert: {e}")



def lambda_handler(event, context):
    if not ALB_DNS_URL:
        logger.error("ALB_DNS_URL environment variable is not set.")
        return

    http = urllib3.PoolManager()

    try:
        logger.info(f"Sending request to {ALB_DNS_URL}")
        response = http.request("GET", ALB_DNS_URL, timeout=10)
        if response.status == 200:
            if b"Hello, World!" in response.data:
                logger.info("Web app is healthy!")
            else:
                logger.error("Web app response does not contain 'Hello, World!'.")
                send_sns_alert()
        else:
            logger.error(f"Unexpected status code: {response.status}")
            send_sns_alert()

    except urllib3.exceptions.HTTPError as e:
        logger.error(f"Error connecting to ALB: {e}")
