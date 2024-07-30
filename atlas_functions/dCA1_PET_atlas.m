function [dCA1_PET] = dCA1_PET_atlas(PET_scan,MRI_atlas)

save_imgs = 0;

%% Slices

% Column 1 - left
    
regions = cell(12,2);
regions{1,1} = [98 49;103 50;106 53;109 59;111 65;111 71;106 79;104 73;105 66;103 58;101 53]; %slice=114
regions{2,1} = [97 48;102 48;106 52;109 57;111 64;111 71;106 79;103 73;105 66;103 58;101 53];%slice=113
regions{3,1} = [95 45;102 47;107 52;109 57;111 64;111 71;106 79;103 73;105 63;103 55;100 50];%slice=112
regions{4,1} = [94 44;99 45;104 48;109 57;111 64;111 71;106 79;103 73;105 63;103 55;100 50];%slice=111
regions{5,1} = [94 44;99 45;104 47;110 56;112 64;111 71;106 79;103 73;105 63;103 55;100 50];%slice=110
regions{6,1} = [93 42;97 42;104 47;110 56;112 63;111 71;106 79;104 72;106 63;103 55;100 50];%slice=109
regions{7,1} = [92 42;98 42;104 46;110 55;112 63;111 71;104 80;102 72;105 63;103 55;100 50];%slice=108
regions{8,1} = [91 40;98 41;104 46;110 55;112 63;111 71;103 80;102 72;105 63;103 55;100 50];%slice=107
regions{9,1} = [91 40;98 41;105 45;110 55;112 63;111 71;103 80;100 72;105 64;103 55;100 50];%slice=106
regions{10,1} = [91 39;98 41;105 45;110 55;112 63;111 71;103 80;100 72;105 64;103 55;100 50];%slice=105
regions{11,1} = [90 37;97 39;105 45;110 55;112 63;110 71;102 80;100 73;105 64;103 55;100 50];%slice=104
regions{12,1} = [90 37;97 39;105 45;110 55;112 63;110 71;102 80;100 73;105 64;103 55;100 50];%slice=103
regions{13,1} = [89 36;97 39;105 45;110 55;112 63;110 71;103 77;101 73;106 63;103 55;97 46];%slice=102
regions{14,1} = [89 36;97 39;105 45;110 55;112 63;110 71;103 77;101 73;106 63;103 55;97 46];%slice=101
regions{15,1} = [86 32;96 36;105 44;111 54;112 63;110 69;104 75;102 71;106 63;103 53;97 45];%slice=100

% Column 2 - right

regions{1,2} = [98 123;103 122;106 119;109 113;111 107;111 101;106 93;104 99;105 106;103 114;101 119];%slice=114
regions{2,2} = [97 124;102 124;106 120;109 115;111 108;111 101;106 93;103 99;105 106;103 114;101 119];%slice=113
regions{3,2} = [95 127;102 125;107 120;109 115;111 108;111 101;106 93;103 99;105 109;103 117;100 122];%slice=112
regions{4,2} = [94 128;99 127;104 124;109 115;111 108;111 101;106 93;103 99;105 109;103 117;100 122];%slice=111
regions{5,2} = [94 128;99 127;104 125;110 116;112 108;111 101;106 93;103 99;105 109;103 117;100 122];%slice=110
regions{6,2} = [93 128;97 127;104 125;110 116;112 108;111 101;106 93;104 99;106 109;103 117;100 122];%slice=109
regions{7,2} = [92 130;98 130;104 126;110 117;112 109;111 101;104 92;102 100;105 109;103 117;100 122];%slice=108
regions{8,2} = [91 130;98 130;105 126;110 117;112 109;111 101;103 92;100 100;105 109;103 117;100 122];%slice=107
regions{9,2} = [91 130;98 130;105 126;110 117;112 109;111 101;103 92;100 100;105 109;103 117;100 122];%slice=106
regions{10,2} = [91 133;98 131;105 127;110 117;112 109;111 101;103 92;100 100;105 108;103 117;100 122];%slice=105
regions{11,2} = [90 135;97 133;105 127;110 117;112 109;110 101;102 92;100 99;105 108;103 117;100 122];%slice=104
regions{12,2} = [90 135;97 133;105 127;110 117;112 109;110 101;102 92;100 99;105 108;103 117;100 122];%slice=103
regions{13,2} = [89 136;97 133;105 127;110 117;112 109;110 101;103 95;101 99;106 109;103 117;97 126];%slice=102
regions{14,2} = [89 136;97 133;105 127;110 117;112 109;110 101;103 95;101 99;106 109;103 117;97 126];%slice=101
regions{15,2} = [86 140;96 136;105 128;111 118;112 109;110 103;104 97;102 101;106 109;103 119;97 127];%slice=100

%% Import atlas, set all values outside of brain to 0
atlas_mask = MRI_atlas;
atlas_mask(atlas_mask<100) = 0;
atlas_mask(atlas_mask>100) = 1;

% Set all PET values outside of MRI atlas and PET brain area to 0
PET_scan(atlas_mask == 0) = 0;  

% Get average for whole brain
% need to delete values outside brain

% Calculate whole brain mean PET value
whole_brain_mean = mean(PET_scan(PET_scan>1e7));

masked_PET = cell(size(regions));
masked_PET_bilateral = cell(size(regions));
masked_PET_nozeros = cell(size(regions));
masked_PET_meanvalue = zeros(size(regions));

slice_number = 114;
% Loop for each slice
for islice = 1:size(regions,1)

    % Isolate single slice
    PET_scan_slice = reshape(PET_scan(:,slice_number,:),[165,135]);

    % Create image of PET scan slice
    % figure
    imshow(PET_scan_slice,[0,max(PET_scan_slice,[],'all')],Colormap=jet)

    % Draw region of interest for left side (column 1 of regions)
    roi_1 = images.roi.Freehand(gca,'Position',regions{islice,1});

    % Create mask for region (left side)
    mask_1 = createMask(roi_1,PET_scan_slice);

    % Apply mask to PET data (left)
    masked_PET{islice,1} = double(PET_scan_slice).*double(mask_1);

    % Normalize PET slice to whole brain mean (left)
    masked_PET{islice,1} = masked_PET{islice,1}./whole_brain_mean;

    % Draw region of interest for right side (column 2 of regions)% Create image of PET scan slice
    % figure
    imshow(PET_scan_slice,[0,max(PET_scan_slice,[],'all')],Colormap=jet)
    roi_2 = images.roi.Freehand(gca,'Position',regions{islice,2});

    % Create mask for region (right side)
    mask_2 = createMask(roi_2,PET_scan_slice);

    % Apply mask to PET data (right)
    masked_PET{islice,2} = double(PET_scan_slice).*double(mask_2);

    % Normalize PET slice to whole brain mean (right)
    masked_PET{islice,2} = double(masked_PET{islice,2})./whole_brain_mean;

    % Get mean value for each slice
    masked_PET_nozeros{islice,1} = masked_PET{islice,1}(masked_PET{islice,1}~=0);
    masked_PET_nozeros{islice,2} = masked_PET{islice,2}(masked_PET{islice,2}~=0);
    masked_PET_meanvalue(islice,1) = mean(masked_PET_nozeros{islice,1});
    masked_PET_meanvalue(islice,2) = mean(masked_PET_nozeros{islice,2});

    % Masked PET both sides
    masked_PET_bilateral{islice} = masked_PET{islice,1} + masked_PET{islice,2};

    % Atlas slice
    atlas_slice = reshape(MRI_atlas(:,slice_number,:),[165,135]);

    % Show atlas slice
    % figure
    % imshow(atlas_slice,[0,max(atlas_slice,[],'all')]);

    if save_imgs == 1
        print(gcf,sprintf('%s/%s_atlas_%d.tiff',save_folder,group_name,slice_number),'-dtiff','-r300')
    end
    % Show image of masked PET
    % figure
    % imshow(masked_PET_bilateral{islice},[],Colormap=jet,DisplayRange=[0.6,1.1])

    if save_imgs == 1
        print(gcf,sprintf('%s/%s_PET_%d.tiff',save_folder,group_name,slice_number),'-dtiff','-r300')
    end
    
    slice_number = slice_number - 1;

end



% output

dCA1_PET = masked_PET_meanvalue;