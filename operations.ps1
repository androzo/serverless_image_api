param (
    [switch]$deployStack,
    [switch]$tearDownStack,
    [switch]$uploadLambda
)

if($uploadLambda){
    # Create S3 bucket to upload lambda functions
    if(!(Invoke-Command -ScriptBlock { aws s3 ls }) -like '*api-test-2019-lambda-functions*'){
        Invoke-Command -ScriptBlock { aws s3api create-bucket --bucket api-test-2019-lambda-functions --region us-east-1 }
    }

    # Zip lambda functions
    Compress-Archive -Path .\functions\list_image\index.py -DestinationPath .\functions\zip\list_image.zip -Update
    Compress-Archive -Path .\functions\save_image\index.py -DestinationPath .\functions\zip\save_image.zip -Update

    # Upload lambda functions to S3
    Invoke-Command -ScriptBlock { aws s3 cp functions/zip/ s3://api-test-2019-lambda-functions/ --recursive }
}

if($deployStack){
    Invoke-Command -ScriptBlock { aws cloudformation create-stack --stack-name api-test --template-body 'file://./infrastructure\s3.json' --capabilities CAPABILITY_NAMED_IAM }
}

if($tearDown){
    Invoke-Command -ScriptBlock { aws cloudformation delete-stack --stack-name api-test }
    Write-Host "Sent tear down command!"
}
