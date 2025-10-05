#!/usr/bin/env python3
"""
clean_country_web.py
- Interactive CLI tool
- Emoji-free, clean text output
- Input: country name or ccTLD
- Output: Official and Unofficial websites
- Works on Termux & Linux
- Uses only Python 3 standard library
"""

import urllib.request
import urllib.parse
import re
import time

DDG_URL = "https://html.duckduckgo.com/html/"

def normalize_input(token):
    token = token.strip().lower()
    if token.startswith('.'):
        token = token[1:]
    return token

def get_official_websites(token):
    """Scrape Wikipedia infobox for official websites using urllib + regex"""
    try:
        wiki_url = "https://en.wikipedia.org/wiki/{}".format(urllib.parse.quote(token.capitalize()))
        req = urllib.request.Request(wiki_url, headers={"User-Agent":"Python-urllib/3"})
        with urllib.request.urlopen(req, timeout=20) as response:
            html = response.read().decode('utf-8', errors='ignore')
        # Extract links from infobox table
        infobox_match = re.search(r'<table class="infobox(.*?)</table>', html, re.DOTALL)
        links = []
        if infobox_match:
            table_html = infobox_match.group(0)
            links = re.findall(r'href="(http[s]?://[^"]+)"', table_html)
        return sorted(list(set(links)))
    except:
        return []

def ddg_search(tld, max_results=15, pause=1.0):
    """Scrape DuckDuckGo HTML for site:.tld using urllib + regex"""
    query = "site:.{}".format(tld)
    data = urllib.parse.urlencode({"q": query}).encode('utf-8')
    try:
        req = urllib.request.Request(DDG_URL, data=data, headers={"User-Agent":"Python-urllib/3"})
        with urllib.request.urlopen(req, timeout=20) as response:
            html = response.read().decode('utf-8', errors='ignore')
        # Extract URLs
        results = []
        hrefs = re.findall(r'href="(https?://[^"]+)"', html)
        for href in hrefs:
            if len(results) >= max_results:
                break
            if ".{}" .format(tld) in href:
                results.append(href)
        time.sleep(pause)
        return sorted(list(set(results)))
    except:
        return []

def guess_tld(token):
    if len(token) == 2 and token.isalpha():
        return token.lower()
    return None

def main():
    print("Welcome to Clean Country Web Scraper!")
    print("Type 'exit' to quit anytime.\n")
    
    while True:
        user_input = input("Enter country name or ccTLD (e.g., Bangladesh, bd, .il): ").strip()
        if not user_input or user_input.lower()=='exit':
            print("\nExiting. Goodbye!")
            break
        
        token = normalize_input(user_input)
        print("\nSearching websites for '{}'...\n".format(user_input))

        # Official websites
        official = get_official_websites(token)
        print("Official Websites (Wikipedia Infobox):")
        if official:
            for u in official:
                print(u)
        else:
            print("No official websites found on Wikipedia.")

        # Unofficial websites
        tld = guess_tld(token)
        if tld:
            unofficial = ddg_search(tld)
            if unofficial:
                print("\nUnofficial / Popular Websites (DuckDuckGo):")
                for u in unofficial:
                    print(u)
            else:
                print("\nNo unofficial websites found for TLD .{}".format(tld))
        else:
            print("\nCould not guess TLD. Skipping unofficial websites search.")
        
        print("\n" + "="*50 + "\n")

if __name__ == "__main__":
    main()