# Results of this stage

| Model   | terraform validate   | Errors with SSH   | Other errors   |
|:-------:|:--------------------:|:----------------:|:---------------:|
| ChatGPT 4o | 0/3 | + | + |
| DeepSeek | 0/3 | + | - |
| YandexGPT Pro | 0/3 | - | + |
| GigaChat 2 Max | 0/3 | - | + |
| Claude 4 Sonnet | 1/3 | + | - |
| Gemini 2.5 Pro | 0/3 | + | - |
| Grok 3 | 0/3 | + | + |
| Mistral | 0/3 | + | - |
| Qwen3 | 0/3 | - | + |

terraform validate - validation of .tf files
Errors with SSH - terraform search .ssh/id_rsa.pub file, but it doesn't exist

[Used prompt](./prompt.txt)
