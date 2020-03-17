use DB_File;

$archivo_DB=$ARGV[1-1];

tie(%memo, "DB_File", $archivo_DB, O_RDWR|O_CREAT, 0666, $DB_BTREE) || die "no puedo abrir arvchivo `mytree': $!";

foreach my $key (keys %memo) {
    
    print "Key: " . $key . ", Mensaje : " . $memo{$key} . "\n";
}

untie %memo;
	