bucket_name = 'deepholdem-amysantiago-bucket'
prefix = 'street-2/'
dl_dir = '/root/forkholdem/Data/TrainSamples/NoLimit/flop/'

storage_client = storage.Client()
bucket = storage_client.get_bucket(bucket_name=bucket_name)
blobs = bucket.list_blobs(prefix=prefix)  # Get list of files
for blob in blobs:
    filename = blob.name.replace('/', '_') 
    blob.download_to_filename(dl_dir + filename)  # Download
