def send_to_webhook(data, context):
  import requests

  if data:
      webhook_url = "https://webhook-domain-here.qa.xcloudiq.com/resource/api/v1/resources/hosts/instances/events/"
      temp_webhook_url = "https://webhook.site/b31d2328-76ac-4787-a069-1af0318095d5"
      headers = {'Content-Type': 'application/json'}

      requests.post(temp_webhook_url, json=data, headers=headers)
      response = requests.post(webhook_url, json=data, headers=headers)

      if response.status_code == 200:
          return "Webhook successfully triggered!"
      else:
          return "Webhook trigger failed."

  return "No data in the request."