function entropy = sistem(s_t)

global p

s = round(s_t(:,1))
t = round(s_t(:,2))

jumlah = length(s);

for alur=1:jumlah


p1 = 0;
p2 = 0;
%s =
%t = 150;
l = 256;
h1 = 0;
h2 = 0;

%probability
%P1
for h=1:s(alur)
	for k=1:t(alur)
		p1 = p1+p(h,k);
	endfor
endfor

%P2
for h=s(alur)+1:l
	for k=t(alur)+1:l
		p2 = p2+p(h,k);
	endfor
endfor

%entropy
%H1
for h=1:s(alur)
	for k=1:t(alur)
		if p(h,k) != 0
		h1 = h1+p(h,k)*log10(p(h,k));
		endif
	endfor
endfor
h1 = -h1;
%H2
for h=s(alur)+1:l
	for k=t(alur)+1:l
		if p(h,k) != 0
		h2 = h2+p(h,k)*log10(p(h,k));
		endif
	endfor
endfor
h2 = -h2;

if p1 != 0
h_area1 = log10(p1)+h1/p1;
else
h_area1 = 0;
endif

if p2 != 0
h_area2 = log10(p2)+h2/p2;
else
h_area2 = 0;
endif

entropy(alur) = h_area1 + h_area2

endfor
