FROM jzollinger/baseline-workstation:rubi8

WORKDIR /root/
RUN rm -rf go  
RUN wget https://go.dev/dl/go1.20.5.linux-amd64.tar.gz
RUN sha256sum go1.20.5.linux-amd64.tar.gz | grep "d7ec48cde0d3d2be2c69203bc3e0a44de8660b9c09a6e85c4732a3f7dc442612"
RUN tar -C /usr/local -xzf go1.20.5.linux-amd64.tar.gz
RUN sed -i '4 i export PATH=$PATH:/usr/local/go/bin' ~/.bashrc
ENV PATH="$PATH:/usr/local/go/bin"

RUN eval $(go env | sed 's/^/export /'); mkdir -p "$GOPATH/src" "$GOPATH/bin"
RUN eval $(go env | sed 's/^/export /'); echo -e "GOPATH current value is '${GOPATH}'"; chmod -R 777 "${GOPATH}"


RUN go install -v golang.org/x/tools/gopls@latest
RUN go install -v github.com/go-delve/delve/cmd/dlv@latest
RUN go install -v github.com/cweill/gotests/...@latest
RUN go install -v github.com/josharian/impl@latest
RUN go install -v gotest.tools/gotestsum@latest
RUN go install -v github.com/koron/iferr@latest

RUN echo -e "finished installing $(go version)"

CMD "/bin/bash"
