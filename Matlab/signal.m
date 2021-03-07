bits_frac = 8;                              % Bits of fractional part

fs = 1;                                     % Signal frequency
fc = fs*100;                                % Sampling frequency
t = 0:1/fc:(1/fs)-(1/fc);                   % Time vector
vpp = 5;                                    % Peak to peak voltage

signal = (vpp/2)+(vpp/2)*sin(2*pi*fs*t);
plot(t,signal)

fid = fopen('sine.txt','w');                % Open the file in write mode
for i=1:length(signal)
    fprintf(fid,'%d\n',round(signal(i)*(2^bits_frac)));
end
fclose(fid);                                % Close the file