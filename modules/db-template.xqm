xquery version "3.0";

module namespace db-template="http://docbook.org/templates";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://docbook.org/apps/doc/config" at "config.xqm";
declare namespace db="http://docbook.org/ns/docbook";

declare 
function db-template:each($node as node(), $model as map(*), $from as xs:string, $to as xs:string) {
    for $item in $model($from)
        return element { node-name($node) } {
        $node/@*, 
        templates:process($node/node(), map:new(($model, map:entry($to, $item))))
    }
};

declare %templates:wrap function db-template:docbook($node as node(), $model as map(*)) as map(*) {
    map { 'db' :=  fn:doc($config:data-root || '/article.xml')/(db:article|db:book) }
};

declare function db-template:db-type($node as node(), $model as map(*)) as map(*) {
    map { 'db-type' := $model('db')/local-name(), 'db-children' := $model('db')/node() }
};

declare %templates:wrap function db-template:model-value($node as node(), $model as map(*), $key as xs:string?) {
    $model($key)
};

declare function db-template:model-value-switch($node as node(), $model as map(*), $key as xs:string?, $list as xs:string?) {
    let $value := $model($key)
    let $seq := fn:tokenize($list, ',')
    let $pos := fn:index-of($seq, $value)
    return if (fn:empty($pos)) then $value else templates:process($node/node()[$pos], $model)
};

declare %templates:wrap function db-template:model-value-text($node as node(), $model as map(*), $key as xs:string?) {
    $model($key)/text()
};

declare function db-template:each($node as node(), $model as map(*), $from as xs:string, $to as xs:string) {
    for $item in $model($from)
    return
            templates:process($node/node(), map:new(($model, map:entry($to, $item))))
};

declare %templates:wrap function db-template:colspec($node as node(), $model as map(*)) {
    attribute { 'width' } { "25%" }
};
declare %templates:wrap function db-template:code($node as node(), $model as map(*)) {
    attribute { 'data-language' } { $node/@language/string() },
    $node/string()
};
