require "helpers"

JSON = (loadfile "libs/JSON.lua")()

json_db = "convidados.json"

-- Cria o JSON se ele não existir
if not fileExists(json_db) then
	criarJson()
end

-- --------------------------------------------------------------------

function adicionarConvidado(nome, cpf)
	local lista = JSON:decode(getFileContents(json_db))

	table.insert(lista["convidados"], {
		["nome"] = nome,
		["cpf"] = cpf
	})

	setFileContents(json_db, JSON:encode(lista))
end

function removerConvidado(cpf, motivo)
	local lista = JSON:decode(getFileContents(json_db))
	local convidado = nil

	-- Remove o convidado
	for index, item in ipairs(lista["convidados"]) do
		if item["cpf"] == cpf then
			convidado = item
			table.remove(lista["convidados"], index)
		end
	end

	-- Adiciona o convidado à lista de removidos
	convidado["motivo"] = motivo

	table.insert(lista["removidos"], convidado)

	setFileContents(json_db, JSON:encode(lista))
end

function listaDeConvidados()
	return JSON:decode(getFileContents(json_db))
end

function verificarConvidado(cpf)
	local lista = JSON:decode(getFileContents(json_db))
	local ret = false

	for index, item in ipairs(lista["convidados"]) do
		if item["cpf"] == cpf then ret = true end
	end

	return ret
end

function criarJson()
	local file = io.open(json_db, "w")

	local json = {
		["convidados"] = {},
		["removidos"] = {}
	}

	file:write(JSON:encode(json))
	file:close()
end