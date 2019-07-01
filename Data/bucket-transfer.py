from google.cloud import storage
import os, time, subprocess

def upload_blob(bucket_name, source_file_name, destination_blob_name):
        """Uploads a file to the bucket."""
        storage_client = storage.Client()
        bucket = storage_client.get_bucket(bucket_name)
        blob = bucket.blob(destination_blob_name)

        blob.upload_from_filename(source_file_name)

        print('File {} uploaded to {}.'.format(
        source_file_name,
        destination_blob_name))

def upload_blob_list(dir):
        directory = os.listdir(dir)
        start = time.time()

        while(True):
                if (len(directory) > 0):        
                        for name in directory:
                                upload_blob('deepholdem-amysantiago-bucket', dir+name, 'street-4-gen-2/'+name)
                                os.remove(dir+name)
                                start = time.time()

                directory = os.listdir(dir)
                end = time.time()
                if (end - start >= 300):
                        subprocess.call("terminate_instance.sh")
                        return
        return

def list_blobs(bucket_name):
    """Lists all the blobs in the bucket."""
    storage_client = storage.Client()
    bucket = storage_client.get_bucket(bucket_name)

    blobs = bucket.list_blobs()

    print(sum(1 for _ in blobs))

list_blobs('deepholdem-amysantiago-bucket')

        

        




