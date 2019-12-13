import boto3
import urllib

def save_image(event, context):
    try:
        s3 = boto3.resource('s3')
        client_s3 = boto3.client('s3')
        img_url = event["url"]
        img_name = event["name"]
        bucket = s3.Bucket("saved_images")

        urllib.urlretrieve(img_url, img_name)

        # test if saves to current dir and upload works

        client_s3.upload_file('images/' + img_name, 'saved_images', img_name)

        return("Successfully saved image to S3")

    except BaseException as error:
        print("Failed to save image to S3")
        return str(error)