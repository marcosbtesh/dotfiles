#!/bin/bash

# If no arguments are provided, show a help menu
if [ $# -eq 0 ]; then
    echo "Usage: news [service] [query]"
    echo "Services:"
    echo "  tech [query]  - getnews.tech (latest news)"
    echo "  hn            - hkkr.in (Hacker News)"
    echo "  crypto [coin] - rate.sx (exchange rates)"
    echo "  reddit        - ssh redditbox.us"
    echo "  nos           - ssh teletekst.nl (Dutch Teletext)"
    exit 1
fi

SERVICE=$1
shift # Remove the first argument (service name)
QUERY=$(printf "+%s" "$@") # Join remaining arguments with '+'
QUERY=${QUERY:1} # Remove the leading '+'

case $SERVICE in
    tech)
        # Uses getnews.tech with optional search query
        [ -n "$QUERY" ] && curl -s "getnews.tech/$QUERY" || curl -s "getnews.tech"
        ;;
    hn)
        # Hacker News feed
        curl -s "hkkr.in"
        ;;
    crypto)
        # rate.sx for crypto rates, optional specific coin
        [ -n "$QUERY" ] && curl -s "rate.sx/$QUERY" || curl -s "rate.sx"
        ;;
    reddit)
        # Reddit via SSH
        ssh redditbox.us
        ;;
    nos)
        # Dutch Teletext via SSH
        ssh teletekst.nl
        ;;
    *)
        echo "Unknown service: $SERVICE"
        exit 1
        ;;
esac