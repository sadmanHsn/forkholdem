from google.cloud import storage

bucket_name = 'deepholdem-amysantiago-bucket'
prefix = 'flop-nonconverted.tar.gz'
dl_dir = '/root/forkholdem/'

storage_client = storage.Client()
bucket = storage_client.get_bucket(bucket_name)
blobs = bucket.list_blobs(prefix=prefix)  # Get list of files
for blob in blobs:
    filename = blob.name.replace('/', '_') 
    blob.download_to_filename(dl_dir + filename)  # Download
