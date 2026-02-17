#!/usr/bin/env python3
"""Extract conversation content from ChatGPT HTML export."""

from html.parser import HTMLParser
import html
import re
import json
import sys


class ChatGPTExtractor(HTMLParser):
    def __init__(self):
        super().__init__()
        self.messages = []
        self.current_role = None
        self.in_message_content = False
        self.depth = 0
        self.content_depth = 0
        self.current_text_parts = []
        self.in_markdown_div = False
        self.markdown_depth = 0
        
    def handle_starttag(self, tag, attrs):
        attr_dict = dict(attrs)
        
        # Detect message author role
        if 'data-message-author-role' in attr_dict:
            self.current_role = attr_dict['data-message-author-role']
            self.current_text_parts = []
        
        # Detect markdown content area (the actual message body)
        classes = attr_dict.get('class', '')
        if 'markdown' in classes and 'prose' in classes:
            self.in_markdown_div = True
            self.markdown_depth = 0
            
        if self.in_markdown_div:
            self.markdown_depth += 1
            
        # Also capture user messages which don't have markdown prose
        if self.current_role == 'user' and tag == 'div' and 'whitespace-pre-wrap' in classes:
            self.in_message_content = True
            self.content_depth = 0
            
        if self.in_message_content:
            self.content_depth += 1
            
        # Handle list items, paragraphs etc with appropriate spacing
        if self.in_markdown_div or self.in_message_content:
            if tag in ('p', 'li', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6'):
                pass  # Will add newline at endtag
            if tag == 'br':
                self.current_text_parts.append('\n')
            if tag in ('h1', 'h2', 'h3', 'h4', 'h5', 'h6'):
                level = int(tag[1])
                self.current_text_parts.append('#' * level + ' ')
            if tag == 'li':
                self.current_text_parts.append('- ')
            if tag == 'strong' or tag == 'b':
                self.current_text_parts.append('**')
            if tag == 'em' or tag == 'i':
                self.current_text_parts.append('*')
            if tag == 'code':
                self.current_text_parts.append('`')
                
    def handle_endtag(self, tag):
        if self.in_markdown_div:
            self.markdown_depth -= 1
            if self.markdown_depth <= 0:
                self.in_markdown_div = False
                # Save message
                if self.current_role:
                    text = ''.join(self.current_text_parts).strip()
                    if text:
                        self.messages.append({
                            'role': self.current_role,
                            'content': text
                        })
                        self.current_text_parts = []
                        self.current_role = None
                        
        if self.in_message_content:
            self.content_depth -= 1
            if self.content_depth <= 0:
                self.in_message_content = False
                if self.current_role == 'user':
                    text = ''.join(self.current_text_parts).strip()
                    if text:
                        self.messages.append({
                            'role': self.current_role,
                            'content': text
                        })
                        self.current_text_parts = []
                        self.current_role = None
                        
        if self.in_markdown_div or self.in_message_content:
            if tag in ('p', 'li', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6'):
                self.current_text_parts.append('\n')
            if tag == 'strong' or tag == 'b':
                self.current_text_parts.append('**')
            if tag == 'em' or tag == 'i':
                self.current_text_parts.append('*')
            if tag == 'code':
                self.current_text_parts.append('`')
                
    def handle_data(self, data):
        if self.in_markdown_div or self.in_message_content:
            self.current_text_parts.append(data)


def main():
    html_path = '/Users/takumauno/novels/constrain/constrain_brain_storming.html'
    output_path = '/Users/takumauno/novels/constrain/extracted_conversation.json'
    
    print(f"Reading HTML file: {html_path}")
    with open(html_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    print(f"File size: {len(content)} bytes")
    print("Parsing HTML...")
    
    extractor = ChatGPTExtractor()
    extractor.feed(content)
    
    messages = extractor.messages
    
    # Deduplicate (sometimes HTML has duplicate messages)
    seen = set()
    unique_messages = []
    for msg in messages:
        key = (msg['role'], msg['content'][:200])
        if key not in seen:
            seen.add(key)
            unique_messages.append(msg)
    
    print(f"Extracted {len(unique_messages)} unique messages ({len(messages)} total)")
    
    # Save as JSON
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(unique_messages, f, ensure_ascii=False, indent=2)
    
    print(f"Saved to: {output_path}")
    
    # Also save a readable text version
    text_path = '/Users/takumauno/novels/constrain/extracted_conversation.md'
    with open(text_path, 'w', encoding='utf-8') as f:
        for i, msg in enumerate(unique_messages):
            role_label = "👤 USER" if msg['role'] == 'user' else "🤖 ASSISTANT"
            f.write(f"## [{i+1}] {role_label}\n\n")
            f.write(msg['content'])
            f.write("\n\n---\n\n")
    
    print(f"Readable version saved to: {text_path}")
    
    # Print first few messages as preview
    print("\n=== PREVIEW (first 3 messages) ===\n")
    for i, msg in enumerate(unique_messages[:3]):
        role = "USER" if msg['role'] == 'user' else "ASSISTANT"
        preview = msg['content'][:300]
        print(f"[{i+1}] {role}:")
        print(preview)
        print("...\n")


if __name__ == '__main__':
    main()
