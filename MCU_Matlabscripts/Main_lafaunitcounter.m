%% Lafa Unit Counter
% Este código têm a finalidade de ler continuamente os valores de contagem
% de 8 canais conectados ao FPGA. Através da GUI, o usuário pode escolher
% a porta com utilizada para comunicação, o tempo de aquisição e a
% quantidade de loops que serão realizados.

%%
clc
clear all
%% Parâmetros Configuráveis

time = input('Entre com o tempo de aquisição: '); % length of the measurement in seconds
loops = input('Quantidade de loops: ');

PORT = 'COM4';
BAUD = 19200;

CHANGE_FILENAME = 1; 

verbose = 0;

%%
file='data_output';
gate = 0.1; % 100 milisegundos, fixo pelo FPGA
samples = time/gate;       % number of samples
% comment='test'; % Usa para salvar os dados em .MAT

%%
MM  = 41;           % 41 -1 = 40-bytes
MAX = samples * MM; % 10*41 = 410

data_iter  = 1;
trigg_iter = 0;
set_iter   = 0;
error_data = 0;

data_parser = zeros(1,8);

data = zeros(1, MAX);
outpt_vector = zeros(samples, 8);

%% Obtain date and time and modify the file name
matlab_time = now;
unix_time = round(8.64e7 * (matlab_time - datenum('1970', 'yyyy')));
% datetime = datestr(matlab_time, 'dd-mm-yyyy HH:MM:SS.FFF')
datetime = datestr(matlab_time, 'yyyymmddHHMMSS');

if CHANGE_FILENAME==1
    file = strcat(file,'-',num2str(datetime));
end

txtfile=strcat('data_output/',file,'.txt');
datafile=strcat('data_output/',file,'.mat');

%% Informações para o usuário
disp(['ID do arquivo: ' file])
disp(['Samples: ' num2str(samples)])
disp('Não desligue este computador.')
disp('Contagem em progresso...')

%%
if ~isempty(instrfind)
    fclose(instrfindall)
    delete(instrfindall)
end

s = serial(PORT, 'BaudRate', BAUD,'DataBits',8,'Parity','none');
s.BytesAvailableFcnCount = 40;
s.BytesAvailableFcnMode = 'byte';
s.BytesAvailableFcn = @instrcallback;
s.InputBufferSize = 512;
fopen(s);

%%
if verbose
    disp(s)
end
flushinput(s);

%%
tic

for iter_loops = 1:loops
    while(set_iter <= samples)
       
        rd = fread(s, 1); % N=1 element into a column vector
        
        if (size(rd,1) == 1)
            
            data_iter = data_iter +1;
            
            data( data_iter ) = bin2dec( strcat('0', dec2bin( rd ) ) ); % cada byte lido, adiciona 1 em data_iter
            %data salva cada byte lido
            
        end
        
        
        % Para a contagem dos canais, nunca vai acontecer de representar um
        % número com 8-bits '1' seguidos. Isso, pois os números são
        % representados no formato {0 7-bits 0 1}.
        % Logo, quando houver '1111 1111', significa que o frame acabou.
        %
        if ( data( data_iter ) == 255 ) % '1111 1111'
            
            trigg_iter = 0; %%Contas os bytes lidos em um frame
            
            if size(data_set, 2) == MM  % numero de colunas, se for 41
                
                set_iter = set_iter +1; %contador de frmes em cada loop
                if verbose
                    disp(['#Frame= ' num2str(set_iter)]) % Number of the current frame
                end
                %%
                if (data_set(1) == 255)
                    
                    for channel = 0:7
                        one_chan = data_set(2+5*channel : 5*channel+6);
                        data_parser(channel+1) = bin2dec(strcat(dec2bin(one_chan(5),7),dec2bin(one_chan(4),7),dec2bin(one_chan(3),7),dec2bin(one_chan(2),7),dec2bin(one_chan(1),7)));
                        % dec2bin(num_dec, 7) representação binária com 7 bits
                        
                    end
                    
                    outpt_vector(set_iter,:) = data_parser(:);
                    
                    baud_divider = bitand(bin2dec('00000000111111111111111111111111'), outpt_vector(set_iter,1)); % 4-bytes = 32-bits
                    
                    parity = bitand(bin2dec('10000000000000000000000000000000'), outpt_vector(set_iter,1))/2^31;
                    
                    outpt_vector(set_iter,1) = baud_divider/BAUD;
                    
                end
            end
            
            if size(data_set,2) > MM
                error_data = error_data+1 ;
            end
            
            data_set = zeros(0);
        end
        
        trigg_iter = trigg_iter + 1;
        
        data_set(trigg_iter)=data(data_iter); %data_set é um vetor que guarda os bytes lidos em cada frame
        
        if verbose
            disp(['#Byte= ' num2str(trigg_iter)])
            disp(['#Sample= ' num2str(data_iter)])
        end
    end
   %salva os dados
    saved_data = outpt_vector(:,2:8); % Salva todos os canais com excessão do A
    save(txtfile,'saved_data','-ASCII', '-append');
    disp(iter_loops);
    flushinput(s);
    
    %set_iter   = 0;

end
toc
disp('Aquisição Finalizada. Dados salvos com sucesso.')

%% Salva os dados
% 
% saved_data = outpt_vector(:,2:8); % Salva todos os canais com excessão do A
% save(txtfile,'saved_data','-ASCII');
% 
% % save(txtfile,'outpt_vector','-ASCII');              % Formato .TXT
% % save(datafile,'outpt_vector','comment','datetime'); % Formato .MAT
% disp('Os dados foram salvos com sucesso.')

%%
fclose(s);
delete(s);
