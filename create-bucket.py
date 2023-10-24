def GenerateConfig(context):
    bucketName = context.properties['bucketName']

    resources = [
        {'name': bucketName,
            'type': 'storage.v1.bucket',
            'properties': {
            'storageClass':'STANDARD',
            }
        }
    ]

    return {'resources': resources}
