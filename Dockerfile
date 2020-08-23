FROM archlinux AS builder

RUN pacman -Syu --noconfirm --needed git base-devel sudo

RUN useradd builduser -m && \
	passwd -d builduser && \
	printf 'builduser ALL=(ALL) ALL\n' | tee -a /etc/sudoers

USER builduser

WORKDIR /home/builduser

RUN git clone https://aur.archlinux.org/yay.git && \
	cd yay && \
	makepkg -si --noconfirm

RUN gpg --recv-keys --keyserver keyserver.ubuntu.com 5CC908FDB71E12C2

RUN yay -Syu --noconfirm msi-perkeyrgb \
	brother-hll2350dw \
	screenrotator-git \
	google-chrome \
	google-cloud-sdk \
	insomnia \
	stern-bin \
	gitflow-avh \
	minecraft-launcher \
	mongodb-bin \
	mongodb-tools-bin \
    visual-studio-code-bin

RUN mkdir repo && \
	cd repo && \
	find /home/builduser/ -type f -name "*.pkg.tar.*" -exec cp {} . \; && \
	repo-add marshians-aur.db.tar.gz *.pkg.tar.*

FROM golang AS go

WORKDIR /

COPY main.go .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main main.go

FROM scratch

COPY --from=go /main /main
COPY --from=go /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs
COPY --from=builder /home/builduser/repo/ /repo/

WORKDIR /

EXPOSE 8080

ENTRYPOINT ["/main"]
