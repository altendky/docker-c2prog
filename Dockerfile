ARG FROM="ubuntu:focal-20210217"
FROM $FROM

RUN dpkg --add-architecture i386
RUN apt-get update --yes

ARG DEBIAN_FRONTEND="noninteractive"
RUN apt-get upgrade --yes
RUN apt-get install --yes --no-install-recommends wine wine32 git

ENV WINEPREFIX=/wine
# Just triggers creation of the Wine configuration so
# that we can copy into it below.
RUN wine xcopy; exit 0

ENV C_ROOT="${WINEPREFIX}/drive_c/"
ARG PF_X86="${C_ROOT}/Program Files (x86)/"
ARG C2PROG_ARCHIVE="C2Prog.tar.gz"
ADD ${C2PROG_ARCHIVE} ${PF_X86}

ENV C2PROG_ROOT="${PF_X86}/C2Prog"
ADD c2p.config "${C2PROG_ROOT}/"
ENV C2PROG_TARGETS="${C2PROG_ROOT}/targets"

COPY C2ProgShell /usr/local/bin/

RUN ln -s "${C2PROG_TARGETS}" /targets

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
