use Net::Ping;

# Iskvieciam pagrindine funkcija
Main();

sub Main {
	
	# Kvieciam funkcija kuri grazina hostu ir/arba IP sarasa masyvo forma
	@list = GetIpOrHost();
	
	# Begalinis ciklas, kadangi noresime tikrinti kas 10s
	while (1) {
		# Tikrinam kiekviena masyve esanti IP ar hosta
		foreach(@list){
			CheckAvailability($_);
		}
		
		# Laukiam 10s
        sleep 10;
	}
}

sub GetIpOrHost {
	
	# Gauname ivedamus hostus ar IP
	print "Iveskite IP adresa arba Host name: \n";
	$line = <STDIN>;
	chomp $line;
	
	# Isvalom 'space' simbolius, kurie yra nereikalingi
	$line =~ s/\s//g;
	
	# Suskaldome ivesta sarasa pagal kableli
	@list = split(/,/,$line); 
	
	# Graziname gauta sarasa
	return @list;
}

sub CheckAvailability{
	
	# Paimame parametra atsiusta i funkcija
	my $host = $_[0];
	
	# Inicializuojam biblioteka/klase, kuri pades pinginti
 	$p = Net::Ping->new();
 	
 	# Tikrinam ar hostas/IP atsako i pinginima
	if ($p->ping($host)){
		print" '$host' yra pasiekiamas.\n";
	}
	else {
		print "'$host' yra nepasiekiamas.\n";
	}
}