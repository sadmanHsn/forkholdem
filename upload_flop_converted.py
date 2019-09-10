from google.cloud import storage

def upload_blob(bucket_name, source_file_name, destination_blob_name):
    """Uploads a file to the bucket."""
    storage_client = storage.Client()
    bucket = storage_client.get_bucket(bucket_name)
    blob = bucket.blob(destination_blob_name)

    blob.upload_from_filename(source_file_name)

    print('File {} uploaded to {}.'.format(
        source_file_name,
        destination_blob_name))

bucket_name = 'deepholdem-amysantiago-bucket'
source_file_name = 'flop-converted.tar.gz'
destination_blob_name = 'flop-converted/flop-converted.tar.gz'

upload_blob(bucket_name, source_file_name, destination_blob_name)
