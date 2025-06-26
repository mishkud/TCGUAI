# TCGUAI (Terraform code generation using AI)
This is my project where i will test different LLM models in generating Terraform code.

Used models:
- ChatGPT 4o
- DeepSeek
- YandexGPT Pro
- GigaChat 2 Max
- Claude Sonnet 4 
- Gemini 2.5 Pro
- Grok 3
- Mistral
- Qwen3

Testing infrastracture:
Two VM's with Managed MySQL

Stages of testing (used prompt in directory):  
1)with_provider - LLM's asked to generate with provider  
2)no_provider - provider will be added manually  
3)no_provider+ssh - also ssh key will be added  
4)new_prompt - different prompt  
5)new_prompt_end - different prompt on english  
6)only_vms - Managed MySQL is removed from testing infrastructure  
7)only_vms_eng - this prompt on english  

You can see results on every step in directories

Final results (validated .tf files/all generated files)
| Model   | terraform validate   |
|:-------:|:--------------------:|
| ChatGPT 4o | 6/21 |
| DeepSeek | 11/21 |
| YandexGPT Pro | 2/21 |
| GigaChat 2 Max | 0/21 |
| Claude 4 Sonnet | 12/21 |
| Gemini 2.5 Pro | 13/21 |
| Grok 3 | 12/21 |
| Mistral | 6/21 |
| Qwen3 | 2/21 |
