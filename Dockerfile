# Base freesurfer Dockerfile from
# https://github.com/jhuguetn/freesurfer/blob/22634439389f5add40a8572a6bd9e4dce3d7dd31/Dockerfile
# It shows the centos package dependencies, and how to set up the freesurfer
# environment without running the SetUpFreeSurfer.sh script.

FROM centos:7

# shell settings
WORKDIR /root

# install utils
RUN yum -y update
RUN yum -y install bc libgomp perl tar tcsh wget vim-common
RUN yum -y install mesa-libGL libXext libSM libXrender libXmu
RUN yum clean all

# install fs
RUN wget -P /opt https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/7.2.0/freesurfer-linux-centos7_x86_64-7.2.0.tar.gz -O fs.tar.gz && \
    tar -zxf /opt/fs.tar.gz -C /usr/local && \
    rm /opt/fs.tar.gz

# setup fs env
ENV OS Linux
ENV PATH /usr/local/freesurfer/bin:/usr/local/freesurfer/fsfast/bin:/usr/local/freesurfer/tktools:/usr/local/freesurfer/mni/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV FREESURFER_HOME /usr/local/freesurfer
ENV FREESURFER /usr/local/freesurfer
ENV SUBJECTS_DIR /usr/local/freesurfer/subjects
ENV LOCAL_DIR /usr/local/freesurfer/local
ENV FSFAST_HOME /usr/local/freesurfer/fsfast
ENV FMRI_ANALYSIS_DIR /usr/local/freesurfer/fsfast
ENV FUNCTIONALS_DIR /usr/local/freesurfer/sessions

# set default fs options
ENV FS_OVERRIDE 0
ENV FIX_VERTEX_AREA ""
ENV FSF_OUTPUT_FORMAT nii.gz

# mni env requirements
ENV MINC_BIN_DIR /usr/local/freesurfer/mni/bin
ENV MINC_LIB_DIR /usr/local/freesurfer/mni/lib
ENV MNI_DIR /usr/local/freesurfer/mni
ENV MNI_DATAPATH /usr/local/freesurfer/mni/data
ENV MNI_PERL5LIB /usr/local/freesurfer/mni/share/perl5
ENV PERL5LIB /usr/local/freesurfer/mni/share/perl5


# fslstats
RUN wget -nv -P /opt https://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-6.0.4-centos7_64.tar.gz -O fsl.tar.gz && \
    tar -zxf /opt/fsl.tar.gz fsl/bin/fslstats -C /usr/local && \
    rm /opt/fsl-*.tar.gz


# Additional code for generating PDF etc
ADD README.md /opt/fs-extensions/
ADD src /opt/fs-extensions/
