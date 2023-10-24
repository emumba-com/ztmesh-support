def send_to_webhook(data, context):
  import requests
  import os

  if data:
      webhook_url = "https://webhook-domain-here.qa.xcloudiq.com/resource/api/v1/cloud-catalogue/gcp-cloud/events/"
      headers = {'Content-Type': 'application/json', "API_KEY": os.environ['secretAccessKey']}
      response = requests.post(webhook_url, json=data, headers=headers)

      if response.status_code == 200:
          return "Webhook successfully triggered!"
      else:
          return "Webhook trigger failed."

  return "No data in the request."