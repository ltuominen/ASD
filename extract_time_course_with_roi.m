% make sure you have SUBJECTS_DIR env set up

a = read_label('pilot1', 'finger')
b = MRIread('/home/lauri/Documents/autism/group/ftap.lh/tap.ffx/osgm/cache.th40.pos.sig.masked.nii.gz')	;
b.vol=zeros(size(b.vol));
b.vol(a(:,1)+1) =1 ;
MRIwrite(b, '/home/lauri/Documents/autism/group/ftap.lh/tap.ffx/osgm/finger.mgz');

d= '/home/lauri/Documents/autism/subjects/pilot1/bold/ftap_fir.lh/tap_fir/';
time = [d 'cespct.nii.gz'];
time = MRIread(time);
timevar = [d 'cesvarpct.nii.gz'];
timevar = MRIread(timevar);

tp = size(time.vol,4);

HRF =[];
HRFvar = [];

for n = 1:tp
    mask = find(b.vol > 0);
    
    temp = time.vol(:,mask,:,n);
    HRF(n) = mean(temp(:));
    
    temp = timevar.vol(:,mask,:,n);
    HRFvar(n) =mean(temp(:));
    
end

HRFsd = sqrt(HRFvar);
x =[1:tp];

% plot data
p1=plot(x, HRF, 'Color', [1 0.2 0.2], 'LineWidth', 2); hold on 

% plot error
dw = HRF-HRFsd;
up = HRF+HRFsd;
fill([x fliplr(x)], [up, fliplr(dw)], [1 0.2 0.2]);
alpha(.3)

% plot line 
p2=plot(x,zeros(1,16),'Color', 'k', 'LineWidth', .1)

box off 
xlim([1,tp])
xlabel('Time')
ylabel('Signal Percentage Change')

addpath('/home/lauri/Documents/FG1/sex_gen')
export_fig('-transparent', '-r300', ['HRF.tiff']);

