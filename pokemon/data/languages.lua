local languages = {
	"Japanese",
	"English",
	"French",
	"Italian",
	"German",
	"Spanish",
	"Korean",
	"Chinese",
	"Chinese 2"
}

for k, v in pairs(languages) do
	languages[v] = k
end

return languages
