import GetAna from '../view/GetAna'
import PostAna from '../view/PostAna';

@Entry
@Component
struct Index {
  @State currentIndex: number = 0;
  private tabsController: TabsController = new TabsController();

  @Builder
  TabBuilder(title: ResourceStr, index: number, selectedImg: Resource) {
    Column() {
      SymbolGlyph(selectedImg)
        .fontSize('24fp')
        .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_OPACITY)
        .symbolEffect(new BounceSymbolEffect(EffectScope.WHOLE, EffectDirection.UP),
          this.currentIndex === index ? true : false)
        .fontColor(this.currentIndex === index ? ['#0a59f7'] : ['#66000000'])
      Text(title)
        .margin({ top: '4vp' })
        .fontSize(10)
        .fontWeight(500)
        .fontColor(this.currentIndex === index ? '#0a59f7' : '#66000000')
    }
    .justifyContent(FlexAlign.Center)
    .height('56vp')
    .width('100%')
    .onClick(() => {
      this.currentIndex = index;
      this.tabsController.changeIndex(this.currentIndex);
    })
  }

  build() {
    Tabs({
      barPosition: BarPosition.End,
      controller: this.tabsController
    }) {
      TabContent() {
        GetAna()
      }
      .padding({ left: '12vp', right: '12vp' })
      .tabBar(this.TabBuilder('GET', 0, $r('sys.symbol.getup_night_light')))

      TabContent() {
        PostAna()
      }
      .padding({ left: '12vp', right: '12vp' })
      .tabBar(this.TabBuilder('POST', 1, $r('sys.symbol.position')))
    }
    .margin({ bottom: '64vp' })
    .width('100%')
    .height('100%')
    .barHeight('80vp')
    .barMode(BarMode.Fixed)
    .onChange((index: number) => {
      this.currentIndex = index;
    })
  }
}