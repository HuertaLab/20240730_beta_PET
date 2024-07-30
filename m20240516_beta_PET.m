clear
close all

%% Input folder paths to data and MRI atlas

folder_path = ...
    '/Users/jstrohl/Data/20240216 Sepsis Fear PET data/20240216 preprocessed nifti files/'

addpath('./atlas_functions')
addpath('./MRI_template')

addpath(folder_path)

%% Import

% Import MRI atlas
MRI_template = niftiread('2011-10-30_MRI-template3.hdr', ...
    '2011-10-30_MRI-template3.img');

% Import nifti files from folder_path
files = dir(sprintf('%s/*.nii',folder_path));

for i = 1:length(files)
    PET_scan = niftiread(files(i).name);
    BLA_PET = BLA_PET_atlas(PET_scan,MRI_template);
    BLA_PET_output(i,:) = [BLA_PET(:,1)',BLA_PET(:,2)'];

    dCA1_PET = dCA1_PET_atlas(PET_scan,MRI_template);
    dCA1_PET_output(i,:) = [dCA1_PET(:,1)',dCA1_PET(:,2)'];

    IL_PET = IL_PET_atlas(PET_scan,MRI_template);
    IL_PET_output(i,:) = IL_PET;

    PL_PET = PL_PET_atlas(PET_scan,MRI_template);
    PL_PET_output(i,:) = PL_PET;

    LEC_PET = LEC_PET_atlas(PET_scan,MRI_template);
    LEC_PET_output(i,:) = [LEC_PET(:,1)',LEC_PET(:,2)'];

    MEC_PET = MEC_PET_atlas(PET_scan,MRI_template);
    MEC_PET_output(i,:) = [MEC_PET(:,1)',MEC_PET(:,2)'];

    vCA1_PET = vCA1_PET_atlas(PET_scan,MRI_template);
    vCA1_PET_output(i,:) = [vCA1_PET(:,1)',vCA1_PET(:,2)'];

    vSUB_PET = vSUB_PET_atlas(PET_scan,MRI_template);
    vSUB_PET_output(i,:) = [vSUB_PET(:,1)',vSUB_PET(:,2)'];

end



