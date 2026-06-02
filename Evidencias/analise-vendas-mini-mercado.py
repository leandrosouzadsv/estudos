import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from collections import Counter
from itertools import combinations

# Inicialização segura do ambiente gráfico para evitar falhas de execução
plt.rcdefaults()

# 1. Carregamento da Base de Dados
import os

arquivo_padrao = 'vendas_mercearia_maio_2026_1000_registros.csv'
entrada = input(f"Informe o caminho do arquivo CSV [{arquivo_padrao}]: ").strip()
arquivo = entrada or arquivo_padrao

# Tenta resolver caminhos relativos em relação ao diretório do script
script_dir = os.path.dirname(os.path.abspath(__file__))
if not os.path.isabs(arquivo):
    caminho_relativo = os.path.join(script_dir, arquivo)
    if os.path.isfile(caminho_relativo):
        arquivo = caminho_relativo

if not os.path.isfile(arquivo):
    print(f"Erro: O arquivo '{arquivo}' não foi encontrado.")
    exit()

try:
    df = pd.read_csv(arquivo, delimiter=';')
except Exception as e:
    print(f"Erro ao ler o arquivo CSV: {e}")
    exit()

# 2. Processamento e Indicadores Gerais (Diagnóstico Quantitativo)
faturamento_total = df['valor_total'].sum()
ranking_quantidade = df.groupby('produto')['quantidade'].sum().sort_values(ascending=False)
ranking_faturamento = df.groupby('produto')['valor_total'].sum().sort_values(ascending=False)

# 3. Mineração de Regras de Associação (Algoritmo para Venda Cruzada Completa)
vendas_agrupadas = df.groupby('numero_venda')['produto'].apply(list)
combinacoes_pares = Counter()

for itens in vendas_agrupadas:
    # Set elimina redundâncias do mesmo item na mesma compra; sorted garante consistência da chave
    itens_unicos = sorted(list(set(itens)))
    if len(itens_unicos) > 1:
        combinacoes_pares.update(combinations(itens_unicos, 2))

# Convertendo o mapeamento completo em um DataFrame estruturado
df_venda_cruzada = pd.DataFrame([
    {"Par de Produtos": f"{par[0]} × {par[1]}", "Frequencia_Conjunta": qtd} 
    for par, qtd in combinacoes_pares.items()
]).sort_values(by="Frequencia_Conjunta", ascending=False).reset_index(drop=True)


# --- EMISSÃO DE RELATÓRIO DO DIAGNÓSTICO (Terminal) ---
print("=" * 70)
print(" DIAGNÓSTICO E TEORIZAÇÃO: ANÁLISE DE DADOS DO PONTOS DE VENDA (PDV)")
print("=" * 70)
print(f"Faturamento Bruto Analisado: R$ {faturamento_total:,.2f}")
print(f"Total de Cupons Únicos Avaliados: {df['numero_venda'].nunique()}\n")

print("--- TOP 5 PRODUTOS COM MAIOR IMPACTO FINANCEIRO (R$) ---")
for prod, valor in ranking_faturamento.head(5).items():
    print(f" - {prod}: R$ {valor:,.2f}")

print("\n--- TOP 5 PRODUTOS COM MAIOR VOLUME DE SAÍDA (UNIDADES) ---")
for prod, qtd in ranking_quantidade.head(5).items():
    print(f" - {prod}: {qtd} unidades")

print("\n--- MAPEAMENTO DINÂMICO COMPLETO DE VENDA CRUZADA (TOP 10 PARES) ---")
print(df_venda_cruzada.head(10).to_string(index=False))


# --- GERAÇÃO INTEGRADA DO PAINEL GRÁFICO ACADÊMICO ---
fig, axes = plt.subplots(2, 2, figsize=(16, 12))

# Gráfico 1: Maiores Faturamentos
top_fat = ranking_faturamento.head(8)
axes[0, 0].barh(top_fat.index[::-1], top_fat.values[::-1], color='#1f77b4', edgecolor='black')
axes[0, 0].set_title('Painel A: Distribuição de Faturamento por Produto (Top 8)', fontsize=12, fontweight='bold')
axes[0, 0].set_xlabel('Arrecadação Total em R$')
axes[0, 0].grid(axis='x', linestyle='--', alpha=0.5)

# Gráfico 2: Maiores Quantidades
top_qtd = ranking_quantidade.head(8)
axes[0, 1].barh(top_qtd.index[::-1], top_qtd.values[::-1], color='#34495e', edgecolor='black')
axes[0, 1].set_title('Painel B: Curva de Volume Físico Escoado (Top 8)', fontsize=12, fontweight='bold')
axes[0, 1].set_xlabel('Unidades Totais Comercializadas')
axes[0, 1].grid(axis='x', linestyle='--', alpha=0.5)

# Gráfico 3: Análise Ampla de Venda Cruzada (Geral)
top_pares_geral = df_venda_cruzada.head(8)
axes[1, 0].barh(top_pares_geral['Par de Produtos'][::-1], top_pares_geral['Frequencia_Conjunta'][::-1], color='#e67e22', edgecolor='black')
axes[1, 0].set_title('Painel C: Comportamento de Consumo - Top 8 Pares Gerais', fontsize=12, fontweight='bold')
axes[1, 0].set_xlabel('Frequência Absoluta de Co-ocorrência em Cupons')
axes[1, 0].grid(axis='x', linestyle='--', alpha=0.5)

# Gráfico 4: Foco na Hipótese do Projeto (Associações Estratégicas Baseadas em Carvão)
df_foco = df_venda_cruzada[df_venda_cruzada['Par de Produtos'].str.contains('Carvao')].head(5)
axes[1, 1].bar(df_foco['Par de Produtos'], df_foco['Frequencia_Conjunta'], color='#27ae60', edgecolor='black', width=0.4)
axes[1, 1].set_title('Painel D: Afinidade Comercial do Produto Isola (Foco: Carvão)', fontsize=12, fontweight='bold')
axes[1, 1].set_ylabel('Quantidade de Vendas Casadas')
axes[1, 1].set_xticklabels(df_foco['Par de Produtos'], rotation=20, ha='right')
axes[1, 1].grid(axis='y', linestyle='--', alpha=0.5)

plt.tight_layout()
# Salva a figura em alta qualidade para anexar diretamente no PDF/PPTX
plt.savefig('diagnostico_mercearia_completo.png', dpi=300)
print("\n" + "=" * 70)
print("[PROCESSO CONCLUÍDO] Gráfico salvo como 'diagnostico_mercearia_completo.png'.")
print("=" * 70)