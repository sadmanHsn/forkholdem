#! /bin/bash

import os
!apt install sudo --yes
!apt install libreadline-dev --yes

!pip install --upgrade google-cloud-storage

os.chdir('/root')
!git clone https://github.com/sadmanHsn/distro.git
!mv distro torch

os.chdir('/root/torch')
!./clean.sh
!export TORCH_NVCC_FLAGS="-D__CUDA_NO_HALF_OPERATORS__" 
!sudo -E TORCH_LUA_VERSION=LUA52 ./install.sh

os.environ['LUA_PATH'] = '/root/.luarocks/share/lua/5.2/?.lua;/root/.luarocks/share/lua/5.2/?/init.lua;/root/torch/install/share/lua/5.2/?.lua;/root/torch/install/share/lua/5.2/?/init.lua;/root/torch/install/lib/lua/5.2/?.lua;/root/torch/install/lib/lua/5.2/?/init.lua;./?.lua;./?/init.lua'
os.environ['LUA_CPATH'] ='/root/.luarocks/lib/lua/5.2/?.so;/root/torch/install/lib/lua/5.2/?.so;/root/torch/install/lib/lua/5.2/loadall.so;./?.so'
os.environ['PATH'] += ':/root/torch/install/bin'

if 'LD_LIBRARY_PATH' not in os.environ.keys():
  os.environ['LD_LIBRARY_PATH'] = ''
else:
  os.environ['LD_LIBRARY_PATH'] += ':'
os.environ['LD_LIBRARY_PATH'] +='/root/torch/install/lib'

if 'DYLD_LIBRARY_PATH' not in os.environ.keys():
  os.environ['DYLD_LIBRARY_PATH'] = ''
else:
  os.environ['DYLD_LIBRARY_PATH'] += ':'
os.environ['DYLD_LIBRARY_PATH'] +='/root/torch/install/lib'

if 'LUA_CPATH' not in os.environ.keys():
  os.environ['LUA_CPATH'] = ''
else:
  os.environ['LUA_CPATH'] += ';'
os.environ['LUA_CPATH'] += '/root/torch/install/lib/?.so'

!luarocks make /root/torch/extra/cutorch/rocks/cutorch-scm-1.rockspec
os.chdir('/root')
!git clone https://github.com/sadmanHsn/forkholdem.git
!cp -av /root/forkholdem/torch/pkg/torch/TensorMath.lua /root/torch/pkg/torch/
!cp -av /root/forkholdem/torch/extra/cutorch/TensorMath.lua /root/torch/extra/cutorch/
!rm -rf forkholdem/torch

os.chdir('/root/torch')
!./clean.sh
!export TORCH_NVCC_FLAGS="-D__CUDA_NO_HALF_OPERATORS__" 
!sudo -E TORCH_LUA_VERSION=LUA52 ./install.sh
!echo ". /root/torch/install/bin/torch-activate" >> ~/.bashrc

!cp -avr /root/forkholdem/* /root/torch/install/share/lua/5.2/

os.chdir('/root/forkholdem/Data/')
!mkdir TrainSamples
!mkdir TrainSamples/NoLimits

os.chdir('/root/forkholdem/Game/Evaluation/')
!unzip HandRanks.zip

os.chdir('/root/forkholdem/DataGeneration/')
!chmod +x upload_files.sh
os.environ['GOOGLE_APPLICATION_CREDENTIALS']="/root/forkholdem/My First Project-7395a67d45e1.json"
!th main_data_generation.lua 3


