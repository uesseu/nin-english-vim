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
let dict = {}

const setupDict = (fname) => {
  if (!loaded){
    const pre_dict = Deno.readTextFileSync(fname)
      .split('\n')
      .map(s=>s.split('\t'))
      .filter(s => s.length === 2)
      .forEach(s => dict[s[0]] = s[1])
    loaded = true
  }
}

type Params = {
};


const suffix = ['', 's', 'es', 'ed', 'is', 'ly', 'ing', 'able', 'lize', 'lized']
const prefix = ['', 'a', 'bi', 'pre', 'mul', 'non', 'hyper']

const setupWord = (token: string) => {
  let tokens = [token]
  let result = 'No result'
  for (const p of prefix)
    for (const s of suffix)
      if (token.slice(token.length-s.length) === s && token.slice(0, p.length) === p)
        result = token.slice(p.length, token.length-s.length)
  return dict[result]
}

export async function main(denops: Denops): Promise<void> {
  denops.dispatcher = {
    async hover(path: string): Promise<unknown> {
      await setupDict(path)
      const token = await fn.expand(denops, '<cword>').then(setupWord)
      return await Promise.resolve(token);
    },
  };
};
