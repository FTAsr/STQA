# Deep Learning Environment Setup Guide for IU Clusters

Below are instructions on how to set up Deep Learning environments on 
hardware available at IU, namely
- Futuresystems
- BigRed2

For instructions on how to setup the environment on your own ubuntu PC, 
you might want to use [this](https://github.com/agent-jay/dl_setup_metaguide)

## Futuresystems

Website:

https://portal.futuresystems.org

Point of Contact: 

- Allan, astreib@indiana.edu

Futuresystems has a number of clusters, but Romeo is one of two GPU clusters
and has the most updated specs.

- 4 nodes 
- 8 NVIDIA K80 GPUs each 
	- Released 2015 
	- 12 GB GDDR5 RAM 
- No data/compute quotas 
- Relatively less used

### Steps to get access to Romeo: 

More detailed instructions [here](http://cloudmesh.github.io/introduction_to_cloud_computing/accounts/details.html)

- Create futuresystems portal account
- Join existing project 
- Create resource account
	- Needs approval from existing project lead (currently Prof. Crandall)
- or, Create a new project
	- One pager with project proposal, impact and resources required 
	- Approved by Geoffrey Fox 
	- Sample https://portal.futuresystems.org/projects/508
- Add SSH key
- You should now be able to login to juliet.futuresystems.org (ssh)

### Additional Notes from Allan:

#### Batch Mode
Nodes on FutureSystems clusters are allocated by the slurm resource
manager. You may want to review the man pages for slurm, and the sinfo,
squeue, sbatch, and srun commands.

Within this folder are two files. The file "theano-test" is a shell script that
sets up the environment and then runs the "theano-test.py" python
program.

If you copy the attached files to your home directory on Juliet, then
you can run the job like:

```
sbatch -p romeo theano-test
```

Slurm will submit it to an available romeo node. Results will end up in
a file called test_NNNN.out where NNNN is the slurm job number.

Note the lines that start with "#SBATCH" are slurm options that control
the format of the output file and the number of nodes and GPUs used.

#### Interactive Mode
You can get interactive access to a node, the easiest way is probably
like:

```
srun -p romeo -N 1 --gres=gpu:1 --pty bash
```

This example will allocate one node, and 1 GPU (look at the environment
variables GPU_DEVICE_ORDINAL and CUDA_VISIBLE_DEVICES for specifics)

There is currently no time limit on allocations but we ask you to be
considerate of other users and log out of any interactive sessions when
they are idle. We do not have quotas or time limits on data, it's more
of an honor system you are expected to be considerate of other users and
clean up any files you don't need when you are done.

#### Miscellaneous
You can install/compile software in your home directory. If you need
something installed in the base system, e.g. additional packages, please
submit a ticket to *help@futuresystems.org*

You can store data in your home directory if it's not too much. This is
an NFS mounted directory.

/share/project is a shared NFS space mounted on all clusters.

/share/jproject is a BeeGFS file system mounted on Juliet and Romeo
nodes. It uses infiniband network so performance should be faster.

We do have some unprovisioned space on each romeo node that could be
made available as scratch space if you need local scratch storage.

It would probably be best if you could submit a description of what you
are doing, how much data storage you need, etc.

### Instructions to setup Anaconda environment for DL

#### For latest version of Tensorflow (1.2) and Keras:

```
ssh <username>@juliet.futuresystems.org
srun -p romeo -N 1 --gres=gpu:1 --pty bash #interactive mode to install software
#now in romeo compute node eg. r001
module load anaconda cuda cudnn
conda create --name dlnew python=3.5 python
source activate dlnew #switch to dlnew anaconda environment
hash -r #if the new env still loads old python version
pip install --ignore-installed --upgrade https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.2.0-cp35-cp35m-linux_x86_64.whl
pip install git+git://github.com/fchollet/keras.git
conda install pygpu
#switch keras backend to tensorflow (or theano if needed)
# edit ~/.keras/keras.json 
#"backend":"tensorflow" ( or "theano")
```

To test if Tensorflow is running on the GPU, follow the instructions shown 
[here](https://stackoverflow.com/a/38019608) or [here](https://stackoverflow.com/a/43703735)

Tensorflow and Keras MUST be installed using pip as shown above and not via conda's
repositories if you'd like them to work together, flawlessly and on the GPU. The
the tensorflow-gpu package from conda did work, but Keras didn't recognize it.
Even the Tensorflow official docs suggest using pip, so that's the safest option. 

In the event that you want to use a newer version (latest as of the time of writing is
TF 1.2), use the same instructions above but change the tensorflow build location
as shown [here](https://www.tensorflow.org/install/install_linux)

#### For older version of Tensorflow (0.11):

The older build of Tensorflow was needed for 

```
ssh <username>@juliet.futuresystems.org
srun -p romeo -N 1 --gres=gpu:1 --pty bash #interactive mode to install software
#now in romeo compute node eg. r001
module load anaconda cuda cudnn
conda create --name dlnew python=3.5 python
source activate dlold #switch to dlold anaconda environment
hash -r #if the new env still loads old python version
#https://stackoverflow.com/a/41193676
pip install --ignore-installed --upgrade https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow-0.11.0-cp35-cp35m-linux_x86_64.whl
```

Then, test out Tensorflow using the same instructions as before.


## BigRed2

Website: 

https://kb.iu.edu/d/bcqt

All queries can be sent to:

- sciapt@iu.edu
For Tensorflow, GPU computing and other package related info (also contacted via the above mailid):

- Cicada 
- Abhinav Thota

Specs:
- 676 nodes
- 1 NVIDIA K20 GPU each
	- Released 2012
	- 5 GB GDDR5 RAM
- Limitations on compute and storage
- Lots of red-tape involved in getting new software

In the time I spent getting the required packages on BigRed2, I found that
