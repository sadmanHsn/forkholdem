from google.cloud import storage
import os

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

        if (len(directory) > 0):        
                for name in directory:
                        upload_blob('deepholdem-amysantiago-bucket', dir+name, 'street-3/street-3-gen-0/'+name)
                        os.remove(dir+name)
        return

upload_blob_list('/root/forkholdem/Data/TrainSamples/NoLimit/')

        

        




