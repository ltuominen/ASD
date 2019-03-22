% script to threshold 
t=MRIread('cache.th40.abs.sig.masked.nii.gz')
t.vol(t.vol<12)=0;

MRIwrite(t, 'activation_20.nii.gz')