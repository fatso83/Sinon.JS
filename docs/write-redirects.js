var semver = require('semver');
var fs = require('fs');
var file = fs.readFileSync('../versions.txt');
var versions = toLineArray(file).filter( s => s.length)
var versionMap = {1:[], 2: [], 3: [], 4: [], 5: [], 6: [], 7: []};
//var versionMap = {7:[]}

function toLineArray(file){
    return file.toString().split('\n');
}

versions.forEach( v => {
    var major = semver.major(v);
    versionMap[major].push(v);
});

//Object.keys(versionMap).forEach( v => {
[7].forEach( v => {
    fs.readdir(`_releases/v${v}`, function(err, files) {
        if(err) {
            console.log(err);
            process.exit(1);
        }

        console.log(versionMap[7])

        files.forEach( f => {
            var basename = f.slice(0,-3);
            var lines = toLineArray(fs.readFileSync(`_releases/v${v}/${f}`));

            var redirectBlock = 'redirect_from: '
            var redirects = versionMap[v].map( fullVersion => `  - /releases/v${fullVersion}/${basename}/`);

            // patch
            lines.splice( 4, 0, redirectBlock, ...redirects)

            var newData = lines.join('\n');
            fs.writeFileSync(`_releases/v${v}/${f}`, newData)
        });
    });
})
