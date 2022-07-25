FROM postgres:13.7-alpine

RUN apk update
RUN apk add gcc make git musl-dev clang llvm

RUN git clone git://git.osdn.net/gitroot/pghintplan/pg_hint_plan.git

RUN cd pg_hint_plan
WORKDIR /pg_hint_plan
RUN git checkout refs/tags/REL13_1_3_7
RUN make
RUN make install

WORKDIR /