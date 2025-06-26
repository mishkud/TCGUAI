# Results of this stage

| Model   | terraform validate   | Errors with Managed MySQL   | Other errors   |
|:-------:|:--------------------:|:----------------:|:---------------:|
| ChatGPT 4o | 1/3 | + | - |
| DeepSeek | 2/3 | - | + |
| YandexGPT Pro | 2/3 | + | + |
| GigaChat 2 Max | 0/3 | + | + |
| Claude 4 Sonnet | 1/3 | + | - |
| Gemini 2.5 Pro | 2/3 | - | + |
| Grok 3 | 2/3 | + | - |
| Mistral | 0/3 | + | - |
| Qwen3 | 0/3 | + | - |

terraform validate - validation of .tf files  
Errors with Managed MySQL - models make mistakes in managed mysql configuration

[Used prompt](./prompt.txt)
