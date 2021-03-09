ARG FROM="python:3.7-slim"
FROM $FROM

RUN dpkg --add-architecture i386
RUN apt-get update --yes

ARG DEBIAN_FRONTEND="noninteractive"
RUN apt-get upgrade --yes
RUN apt-get install --yes --no-install-recommends wine wine32 git

ENV WINEPREFIX=/wine
RUN mkdir "${WINEPREFIX}"
# Just triggers creation of the Wine configuration so
# that we can copy into it below.
RUN wine xcopy; exit 0

ENV C_ROOT="${WINEPREFIX}/drive_c/"
ARG PF_X86="${C_ROOT}/Program Files (x86)/"
RUN mkdir --parents "${PF_X86}"
ARG C2PROG_ARCHIVE="C2Prog.tar.gz"
ADD ${C2PROG_ARCHIVE} ${PF_X86}

ENV C2PROG_ROOT="${PF_X86}/C2Prog"
ADD c2p.config "${C2PROG_ROOT}/"
ENV C2PROG_TARGETS="${C2PROG_ROOT}/targets"
RUN mkdir --parents "${C2PROG_TARGETS}"

COPY C2ProgShell /usr/local/bin/

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
