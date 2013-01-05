use strict;
use warnings;

#Manages all resources which are accessible through the HTTP server
package ResourceHandler;

#Contains all resources which are allowed to the clients
my %_resources = (
	'index.htm' => 'text/html',
	'css/images/header.gif' => 'image/gif',
	'css/images/windows-icon.png' => 'image/png',
	'css/images/linux-icon.png' => 'image/png',
	'css/images/subheader.png' => 'image/png',

	'js/jqxcore.js' => 'application/x-javascript',
	'js/jqxwindow.js' => 'application/x-javascript',
	'js/jqxdocking.js' => 'application/x-javascript',
	'js/jqxtooltip.js' => 'application/x-javascript',
	'js/jqxslider.js' => 'application/x-javascript',
	'js/jqxbuttons.js' => 'application/x-javascript',
	'js/jqxnumberinput.js' => 'application/x-javascript',
	'js/jquery-1.8.2.min.js' => 'application/x-javascript',
    'js/plainvm.js' => 'application/x-javascript',
    'js/mustache.js' => 'application/x-javascript',
    'js/jqxvalidator.js' => 'application/x-javascript',
    'js/jqxtabs.js' => 'application/x-javascript',
    'js/jqxchart.js' => 'application/x-javascript',
    'js/jqxdata.js' => 'application/x-javascript',
	
	'css/jqx.base.css' => 'text/css',
	'css/jqx.fresh.css' => 'text/css',
	'css/styles.css' => 'text/css',
	'css/images/close.png' => 'image/png',,
	'css/images/icon-up.png' => 'image/png',
	'css/images/icon-down.png' => 'image/png',
	'css/images/icon-up-white.png' => 'image/png',
	'css/images/icon-down-white.png' => 'image/png',
	'css/images/not-running.png' => 'image/png',
    'css/images/loading.gif' => 'image/gif',

	'css/images/404.jpg' => 'image/jpg',
	'css/images/plainvm-logo.png' => 'image/png',
	'css/images/startvm.png' => 'image/png',
	'css/images/poweroffvm.png' => 'image/png',
	'css/images/shutdownvm.png' => 'image/png',
	'css/images/menuvm.png' => 'image/png',
	'css/images/icon-right.png' => 'image/png',
	'css/images/icon-left.png' => 'image/png',
	'css/images/multi-arrow.gif' => 'image/gif',
	'css/images/icon-left-white.png' => 'image/png',
	'css/images/icon-right-white.png' => 'image/png',

	'css/images/favicon.ico' => 'image/png'
);

my $_notfound = 'notfound.htm';
my $_server_error = 'notfound.htm';
my $_prefix_dir = 'web/';

sub _prepare_resource($) {
    my $resource = shift;
    return 'index.htm' if $resource eq '/';
    return substr($resource, 1, length($resource) - 1) if defined($resource);
}

sub get_resource($) {
	my $file = shift;
	my $file_content = '';
    $file = _prepare_resource($file);
    if (!$_resources{$file}) {
        return undef;
    }
    $file = $_prefix_dir . $file;
    if (open(FH, '<', $file)) {
        while (<FH>) {
            $file_content .= $_;
        }
        close(FH);
        return $file_content;
    }
    return undef;
}

sub get_mime_type($) {
    my $file = shift;
    $file = _prepare_resource($file);
    my $type = $_resources{$file};
    return $type;
}

sub get_server_error {
	my $content = '';
	open FH, '<' . $_server_error;
	while (<FH>) {
		$content .= $_;
	}
	return $content;
}

sub get_not_found {
	my $content = '';
    my $file = $_prefix_dir . $_notfound;
	open(FH, '<' . $file);
	while (<FH>) {
		$content .= $_;
	}
	return $content;
}

return 1;