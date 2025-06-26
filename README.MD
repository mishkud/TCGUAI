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

You can see results on every stage in directories:
- res.txt file in every model directory. The following one-liner was used to test the files:  
```
for i in {1..3}; do echo "File №$i" ; echo "main_$i" >> res.txt ; mv main_$i main_$i.tf && echo "Installing Provider" ; terraform init 1>/dev/null && echo "Writing results" ; terraform validate -no-color 1>>res.txt 2>>res.txt ; rm -rf .terraform* ; mv main_$i.tf main_$i; done
```
- table with results of stage

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
