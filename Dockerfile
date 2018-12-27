FROM alpine:edge

# Set Timezone
ENV TIMEZONE Asia/Jakarta
RUN apk update && apk add --no-cache tzdata ca-certificates \
    && cp /usr/share/zoneinfo/`echo $TIMEZONE` /etc/localtime && \
    apk del tzdata
    
RUN apk add --no-cache \
            xvfb \
            # Additionnal dependencies for better rendering
            ttf-freefont \
            fontconfig \
            dbus

    # Install wkhtmltopdf from `testing` repository
RUN apk add qt5-qtbase-dev \
            wkhtmltopdf \
            --no-cache

    # Wrapper for xvfb
RUN mv /usr/bin/wkhtmltopdf /usr/bin/wkhtmltopdf-origin && \
    echo $'#!/usr/bin/env sh\n\
Xvfb :0 -screen 0 1024x768x24 -ac +extension GLX +render -noreset & \n\
DISPLAY=:0.0 wkhtmltopdf-origin $@ \n\
killall Xvfb\
' > /usr/bin/wkhtmltopdf && \
    chmod +x /usr/bin/wkhtmltopdf
