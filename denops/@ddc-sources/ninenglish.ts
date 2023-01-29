import {
  BaseSource,
  DdcOptions,
  Item,
  SourceOptions,
} from "https://deno.land/x/ddc_vim@v3.2.0/types.ts";
import {
  assertEquals,
  Denops,
  vars,
  fn,
} from "https://deno.land/x/ddc_vim@v3.2.0/deps.ts";

let loaded = false
let dict: Item[]

const setupDict = (fname) => {
    if (!loaded)
      dict = Deno.readTextFileSync(fname)
        .split('\n')
        .map(s=>s.split('\t'))
        .filter(s => s.length === 2)
        .map(s=> <Item>{word: s[0],
             info: s[1].replace(/\//g, '\n').replace(/;/g, '\n'),
        dup: true})
    loaded = true
}

type Params = {
};

export class Source extends BaseSource<Params> {
  override async gather(args: {
    denops: Denops;
    options: DdcOptions;
    sourceOptions: SourceOptions;
    sourceParams: Params;
    completeStr: string;
  }): Promise<Item[]> {
    setupDict(args.sourceOptions['dict_fname'])
    return dict
  }
}
