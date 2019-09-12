from google.cloud import storage

bucket_name = 'deepholdem-amysantiago-bucket'
prefix = 'flop-nonconverted.tar.gz'
dl_dir = '/root/forkholdem/flop-nonconverted.tar.gz'

storage_client = storage.Client()
bucket = storage_client.get_bucket(bucket_name)
blob = bucket.list_blob(prefix=prefix)  # Get list of files
blob.download_to_filename(dl_dir)  # Download
