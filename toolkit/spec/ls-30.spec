%define         _module ls-30

%{!?svn_revision:%define svn_revision 1}

# COMPATIBILITY FIX: Jenkins job name is neccessary to make build root unique (for CentOS5 and earlier)
%{!?JOB_NAME:%define JOB_NAME standalone}

Name:           docker-ls-30
Version:        1.0
Release:        %{svn_revision}%{?dist}
Summary:        LS-30 toolkit

Group:          System/Tools
License:        GPLv3
URL:            https://github.com/nickandrew/LS30
Packager:       Roman Pavlyuk <roman.pavlyuk@gmail.com>
Source:         %{_module}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)-%{JOB_NAME}
BuildArch:      noarch

Requires:       perl-TimeDate
Requires:       perl-Data-Dumper
Requires:       perl-AnyEvent
Requires:       perl-YAML
Requires:       perl-Mojolicious
Requires:       perl-Digest-MD5
Requires:       perl-Digest-SHA
Requires:       perl-Compress-Raw-Zlib

Conflicts:	docker-ls-30

%description
LifeSOS LS-30 toolkit written in PERL

%define         pkg_user lifesos
%define         pkg_group %{pkg_user}

%package -n perl-LS30

Group:		PERL/Libraries
Summary:	PERL library for LS-30 toolkit

%description -n perl-LS30
PERL library for LS-30 toolkit

%prep
%setup -n %{_module}

%build
# Nothing to do

%install
# Create build directory
rm -rf "$RPM_BUILD_ROOT"
mkdir -p "$RPM_BUILD_ROOT"

### LIBRARY
mkdir -p "$RPM_BUILD_ROOT"%{perl_vendorlib}
cp -a LS30/lib/* "$RPM_BUILD_ROOT"%{perl_vendorlib}


#mkdir -p $RPM_BUILD_ROOT/%{_unitdir}
#cp -a src/*.service $RPM_BUILD_ROOT/%{_unitdir}

#mkdir -p $RPM_BUILD_ROOT/%{_sysconfdir}/sysconfig
#cp -a src/%{_module}.conf $RPM_BUILD_ROOT/%{_sysconfdir}/sysconfig/%{_module}

#mkdir -p $RPM_BUILD_ROOT/%{_bindir}
#cp -a src/docker-ls-30 $RPM_BUILD_ROOT/%{_bindir}/docker-ls-30

%files
%doc

#%config(noreplace) %{_sysconfdir}/sysconfig/%{_module}

#%attr(0755,root,root) %{_bindir}/docker-ls-30

#%{_unitdir}/*.service

%files -n perl-LS30
%{perl_vendorlib}/*

%pre
getent group %{pkg_group} >/dev/null || groupadd -r -g 1122 %{pkg_group}
getent passwd %{pkg_user} >/dev/null || \
    useradd -r -u 1133 -g %{pkg_group} -d %{_sharedstatedir}/%{_module} -s /sbin/nologin \
    -c "LS-30 control account" %{pkg_user}
exit 0
