#!/usr/bin/env python3
import sys
import requests
import json
import urllib.parse

def translate_text(text, source_lang, target_lang):
    """Translate text using MyMemory API (free, no API key needed)"""
    try:
        # Clean the input
        text = text.strip()
        if not text:
            return "Translation failed"
            
        # MyMemory API endpoint
        url = "https://api.mymemory.translated.net/get"
        params = {
            'q': text,
            'langpair': f"{source_lang}|{target_lang}"
        }
        
        # Make request with timeout
        response = requests.get(url, params=params, timeout=10)
        response.raise_for_status()
        
        data = response.json()
        
        if 'responseData' in data and 'translatedText' in data['responseData']:
            translated = data['responseData']['translatedText']
            return translated if translated else "Translation failed"
        else:
            return "Translation failed"
            
    except Exception as e:
        print(f"Translation error: {e}", file=sys.stderr)
        return "Translation failed"

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: web-translator.py <source_lang> <target_lang> <text>")
        sys.exit(1)
    
    source_lang = sys.argv[1]
    target_lang = sys.argv[2] 
    text = sys.argv[3]
    
    result = translate_text(text, source_lang, target_lang)
    print(result)