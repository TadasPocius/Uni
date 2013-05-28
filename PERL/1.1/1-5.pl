use File::Copy;
use POSIX qw/strftime/;
use Cwd qw(abs_path);
use MIME::Lite;
use Net::SMTP;

# Pasiziurim kur yra programa, kelio sufleravimui
my $path = abs_path();

# Paprasom ivesti kelia iki kopijuojamo katalogo
print "Iveskite kelia iki katalogo ir katalogo pavadinima, kuri norite kopijuoti(programos buvimo vieta $path):";
$srcPath = <STDIN>;
chomp $srcPath;

# Patikrinam ar katalogas egizsuotja jei ne, tai paprasom ivesti is naujo ir vel is naujo tikrinam
while (-d $srcPath ne 1){
	print "Katalogas neegzistuoja. Iveskite is naujo:";
	$srcPath = <STDIN>;
	chomp $srcPath;
}

# Paprasom nurodyti i kur kopijuosim kataloga
print "Iveskite kelia iki katalogo, kuriame norite issaugoti kopijuojama kataloga: ";
$destPath = <STDIN>;
chomp $destPath;

# Patikrinam ar katalogas egizsuotja ir ar turimos rasymo teises jei ne, tai paprasom ivesti is naujo ir vel is naujo tikrinam
while ($pathSafe ne 1){
	if(-d $destPath && -w $destPath){
		$pathSafe = 1
	}
	else{
		print "Katalogas neegzistuoja arba neturite rasymo teisiu. Iveskite is naujo: ";
		$srcPath = <STDIN>;
		chomp $srcPath;
		$pathSafe = 0;
	}
}

# Paprasom ivesti nauja katalogo pavadinima arba paliekam sena jei naujas pavadinimas neivestas
print "Iveskite nauja katalogo pavadinima: ";
$newFolder = <STDIN>;
chomp $newFolder;

if($newFolder eq ""){
	print "Katalogo pavadinimas isliks nepakites.\n";
	@subFolders = split('/', $srcPath);
	$newFolder = $subfolders[-1];
}
else {
	print "Nukopijuotas katalogas vadinsis $newFolder.\n";
}

# Sukuriame nauja kataloga
$newPath = $destPath.'/'.$newFolder;
mkdir $newPath, 0755;

# Pasiruosiam faila loginimui
open FILE, ">", $newPath."/pakeitimai.log";

# Rekursyviai skaitom kataloga, kopijuojam failus. pervadinam kuriuos reikia ir loginam pakeitimus
moveFilesRecursively($srcPath, $newPath, FILE);

close(FILE);

### Funkcijos
sub moveFilesRecursively {
	
	my $src = $_[0];
	my $dest = $_[1];
	my $log = $_[2];
	
	
	opendir DIR, $src;
	my @list = readdir DIR;
	closedir DIR;
	
	foreach (@list) {
		if($_ ne "." && $_ ne ".."){
			if(-d $src.'/'.$_){
				print "Sukuriamas naujas vidinis katalogas: $_ @ ".strftime("%Y-%m-%d", localtime)."\n";
				mkdir $dest.'/'.$_, 0755;
	   			moveFilesRecursively($src.'/'.$_, $dest.'/'.$_, $log);
	   		}
	   		else {
	   			copy($src.'/'.$_,$dest);
	   			print "Kopijuojamas failas: $_ @ ".strftime("%Y-%m-%d", localtime)."\n";
	   			if($_ =~ /(\.log)$/){
					print "Keiciamas failo $_ pavadinimas i $_.old @ ".strftime("%Y-%m-%d", localtime)."\n";
					rename($dest."/".$_, $dest."/".$_.".old")."\n";
					print $log strftime("%Y-%m-%d", localtime)." Failo $_ pavadinimas pakeistas i $_.old\r\n";
				}
	   		}
		}
	}
}
