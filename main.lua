require "helpers"
require "convidados"

::begin::
print("Lista de Convidados v0.1.0")
print("-------------------------------------------------------------------------------")
print("Este projeto faz parte da serie de desafios proposta pela pagina")
print("Bugguinho Developer (http://fb.com/BugginhoDeveloper) como uma forma de")
print("estimular programadores a experimentar novas linguagens")
print("")
print("Insira um comando. Para mais informacoes insira 'ajuda'")

::cmd::
print("")
io.write("> ")
cmd_line = io.read()

cmd_line = string.gmatch(cmd_line, "%S+")

cmd = cmd_line(1)
arg1 = cmd_line(2)

if cmd == "ajuda" then
	-- Ajuda e comandos
	print("")
	print("Lista de comandos:\n")
	print("ajuda                    Mostra esta tela")
	print("limpar                   Limpa a tela")
	print("lista [removidos|<cpf>]  Exibe a lista de convidados ou")
	print("                           convidados removidos e verifica se um")
	print("                           convidado esta na lista")
	print("remover                  Remove um convidado da lista")
	print("sair                     Finaliza o programa")
	print("novo                     Adiciona um novo convidado a lista")
	print("recomecar                Zera toda a lista de conviados atual")

	goto cmd
	
elseif cmd == "limpar" then
	-- Limpa a tela
	if getOS() == "unix" then
		os.execute("clear")
	else
		os.execute("cls")
	end
	
	goto begin

elseif cmd == "lista" then
	-- Mostra a lista de convidados
	local lista = listaDeConvidados()
	local cpf_pad = 15; nome_pad = 20

	if arg1 == nil then
		print("LISTA DE CONVIDADOS\n")

		if tableLength(lista["convidados"]) == 0 then
			print("Nenhum convidado na lista")
		else
			print(strPadR("CPF", cpf_pad) .. "Nome")
			print(strPadR("---", cpf_pad) .. "----")

			for index, item in ipairs(lista["convidados"]) do
				print(strPadR(item["cpf"], cpf_pad) .. item["nome"])
			end
		end
	elseif arg1 == "removidos" then
		print("LISTA DE CONVIDADOS REMOVIDOS\n")

		if tableLength(lista["removidos"]) == 0 then
			print("Nenhum convidado foi removido da lista")
		else
			print(strPadR("CPF", cpf_pad) .. strPadR("Nome", nome_pad) .. "Motivo")
			print(strPadR("---", cpf_pad) .. strPadR("----", nome_pad) .. "------")

			for index, item in ipairs(lista["removidos"]) do
				print(strPadR(item["cpf"], cpf_pad) .. strPadR(item["nome"], nome_pad) .. item["motivo"])
			end
		end
	else
		print("CONSULTA DE CONVIDADOS\n")

		if not verificarConvidado(arg1) then
			print("Nenhum convidado encontrado com o CPF '" .. arg1 .. "'")
		else
			print(strPadR("CPF", cpf_pad) .. "Nome")
			print(strPadR("---", cpf_pad) .. "----")

			for index, item in ipairs(lista["convidados"]) do
				if item["cpf"] == arg1 then
					print(strPadR(item["cpf"], cpf_pad) .. item["nome"])
				end
			end
		end
	end

elseif cmd == "remover" then
	-- Remover um convidado da lista (argumentos: cpf)
	io.write("CPF (somente numeros): ")
	local cpf = io.read()

	if cpf == "" then
		print("(!) cancelado") 
		goto cmd
	end

	io.write("Motivo: ")
	local motivo = io.read()

	if motivo == "" then
		print("(!) cancelado") 
		goto cmd
	end

	removerConvidado(cpf, motivo)

	print("")
	print("(OK) Convidado removido com sucesso!")

elseif cmd == "sair" then
	-- Finaliza o programa
	return

elseif cmd == "novo" then
	-- Adicionar novo convidado
	io.write("Nome: ")
	local nome = io.read()
	
	if nome == "" then
		print("(!) Inclusao cancelada") 
		goto cmd
	end

	io.write("CPF (somente numeros): ")
	local cpf = io.read()

	if cpf == "" then
		print("(!) Inclusao cancelada") 
		goto cmd
	end

	if verificarConvidado(cpf) then
		print("(!) Este convidado ja esta na lista")
		goto cmd
	end

	adicionarConvidado(nome, cpf)

	print("")
	print("(OK) Convidado incluido com sucesso!")

elseif cmd == "recomecar" then
	-- Zerar a lista de convidados atual
	criarJson()

	print("(OK) A lista de convidados foi apagada")

else
	if cmd == nil then
		print("(!) Insira um comando ou 'ajuda'")
	else
		print("(!) Comando '" .. cmd .. "' invalido insira 'ajuda'")
	end
end

goto cmd