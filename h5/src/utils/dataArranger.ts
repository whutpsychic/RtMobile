// 将数组数据整理成树型数据
// 关键字段 prentId / id / locationName
function arrangeTreeData(dataArr: any[]) {
  const result = dataArr.filter((item: any) => {
    return !item.parentId
  })

  __loopPutAsTreeData__(result, dataArr)

  return result
}

// 整理树型数据的辅助函数
function __loopPutAsTreeData__(targetArr: any[], dataArr: any[]) {
  targetArr.forEach((item: any) => {
    const kids = dataArr.filter((_item_: any) => {
      return _item_.parentId === item.id
    })
    if (kids.length > 0) {
      item.children = kids
      __loopPutAsTreeData__(kids, dataArr)
    }
  })
}

export { arrangeTreeData }
