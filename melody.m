mel_pop = 30;

for i = 1:mel_pop
    melodi(i) = melody_bar;
    j = 1;
    cnt = [];
    crt = [];
    while j <= 16
        note = global_best(j, randi([1 3], [1 1]));
        tmp = max(floor(note)+24);
        cnt =[tmp, randi([tmp-6 tmp+6])];
        crt = [crt; cnt];
        j = j + 1;
    end
    melodi(i).pos = crt;
    melodi(i).my_best = melodi(i).pos;
end


mel_glob_best = [];
mel_glob_score = inf;
n1 = 1;
c = 1;
clear('tl');
wmel = 1;
wmeldump = 0.9999;
post_prev_score = mel_glob_score;

%run PSO loop
while mel_glob_score >= 5
    %update local best positions.
    for i = 1:mel_pop
        f = melodi(i).score;
        melodi(i).score = melodi(i).fitness();
        if melodi(i).score < f
             melodi(i).my_best = melodi(i).pos;
        end
        
        if melodi(i).score < mel_glob_score
            mel_glob_score = melodi(i).score;
            mel_glob_best = melodi(i).pos;
            c = i;
        end
    end
    
    %update position
    for i = 1:mel_pop
        melodi(i).vel(:,2) = wmel*melodi(i).vel(:,2) + ...
                            1.2*rand().*(melodi(i).my_best(:,2) - melodi(i).pos(:,2)) + ...
                            1.2*rand().*(mel_glob_best(:,2) - melodi(i).pos(:,2));
        if mel_glob_score == post_prev_score
            j = 1;
            cnt = [];
            crt = [];
            while j <= 16
                note = global_best(j, randi([1 3], [1 1]));
                tmp = max(floor(note)+24);
%                 cnt =[tmp, randi([tmp-6 tmp+6])];
                crt = [crt; tmp];
                j = j + 1;
            end
            melodi(i).pos(:,1) = crt;
        end
        melodi(i).pos(:,2) = mod(melodi(i).pos(:,2) + melodi(i).vel(:,2),12)+72;
    end
    if mod(n1,20) == 0
        post_prev_score = mel_glob_score;
    end
    n1 = n1 + 1;
%     wmel = wmel * wmeldump;
    mel_glob_score
end
temp = [];
j = 1;
while j <= 16
   if mel_glob_best(j,1) >= 84 
        mel_glob_best(j,1) = mel_glob_best(j,1)-12;
   end
   
   if mel_glob_best(j,2) >= 84 
        mel_glob_best(j,2) = mel_glob_best(j,2)-12;
   end
   temp = [temp; mel_glob_best(j,1); mel_glob_best(j,2)]; 
   j = j+1;
end
melodic = createnmat(floor(temp)', 0.25, 120);
song = [melodic; chords];
writemidi(song, 'song.mid')