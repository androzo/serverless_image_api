# API Test

This stack will create two APIs that will save an image to an S3 bucket and list all objects in the bucket

## AWS Resources
- 

## Requirements

* AWS cli installed and configured https://docs.aws.amazon.com/pt_br/cli/latest/userguide/cli-chap-install.html
* Postman (or another AWS Signature compatible tool)

### Deploy
```
$ make all
```

### Destroy
```
$ make delete_all
```

### Update
```
$ make update
```

TODO: insert/describe other make cmdlets


## Testing

### Access
1. Access your AWS Console and go to IAM service
2. Click on Users > api_caller > Security credentials and create a new access key
3. This key will be used to authenticate your requests

### Save image API
1. Access your AWS Console and go to API Gateway service
2. Click on the 'save_image_api' and navigate to Stages
3. Click on the 'dev' stage and you should see the invoke URL on the right top of the Console
4. Open your Postman and create a new POST request with following the options:
    * URL: https://your_invoke_url/dev/save_image
    * Body: application/json:
        ```
        {
            url: "https://images.pexels.com/photos/170811/pexels-photo-170811.jpeg",
            name: "sample_image_name.jpeg"
        }
        ```
    * Authorization: AWS Signature
        * Input your access/secret/region for your 'api_caller' user
        * In the service you should use 'execute-api'
5. Response:
    * If everything worked you will see a "Saved image to S3" message on the response body


### List images API
1. Access your AWS Console and go to API Gateway service
2. Click on the 'list_images_api' and navigate to Stages
3. Click on the 'dev' stage and you should see the invoke URL on the right top of the Console
4. Open your Postman and create a new POST request with following the options:
    * URL: https://your_invoke_url/dev/save_image
    * Body is not required
    * Authorization: AWS Signature
        * Input your access/secret/region for your 'api_caller' user
        * In the service you should use 'execute-api'
5. Response:
    * If everything worked you will see a "Saved image to S3" message on the response body
